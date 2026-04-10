"""
Process raw sources into knowledge articles.

Reads articles, files, or repositories from the `raw/` directory, 
uses the LLM to extract knowledge into the `knowledge/` base, 
and then moves the source files to the `processed/` directory.

Usage:
    uv run python scripts/process_raw.py
"""

import os
import shutil
import sys
from pathlib import Path

from config import RAW_DIR, PROCESSED_DIR, AGENTS_FILE, now_iso
from utils import read_wiki_index, list_wiki_articles, run_agent

def process_item(item_path: Path) -> bool:
    print(f"Processing: {item_path.name}...")
    
    schema = AGENTS_FILE.read_text(encoding="utf-8")
    wiki_index = read_wiki_index()
    timestamp = now_iso()
    
    is_dir = item_path.is_dir()
    item_type = "Directory (Repository/Folder)" if is_dir else "File"
    
    prompt = f"""You are a knowledge compiler. Your task is to process a raw input source and extract knowledge from it into the personal wiki.

## Target Item to Process
Path: {item_path.absolute()}
Type: {item_type}

## Instructions
1. Use your tools (`read_file`, `list_directory`, `glob`, `grep_search`) to thoroughly examine the target item.
2. Extract key concepts, facts, insights, and patterns.
3. Create or update concept articles in `knowledge/concepts/[category]/` following the exact schema. You MUST group related concepts into logical subdirectories (e.g., `knowledge/concepts/ml/`, `knowledge/concepts/web/`). Do not put them flatly in `concepts/`.
4. If there are cross-cutting insights, create `knowledge/connections/` articles.
5. Update `knowledge/index.md` with the new entries.
6. Append a log entry to `knowledge/log.md` about processing this raw source.

## Schema (AGENTS.md)
{schema}

## Current Wiki Index
{wiki_index}

Process the item now and write the knowledge files. 
Do NOT ask for confirmation, just execute the plan using your tools.
"""
    
    output = run_agent(prompt, approval_mode="auto_edit")
    
    if "ERROR" in output:
        print(f"  [Failed] Agent error: {output}")
        return False
        
    print(f"  [Success] Knowledge extracted from {item_path.name}.")
    return True

def main():
    if not RAW_DIR.exists():
        RAW_DIR.mkdir()
    if not PROCESSED_DIR.exists():
        PROCESSED_DIR.mkdir()
        
    items = list(RAW_DIR.iterdir())
    if not items:
        print("No items found in raw/ directory. Place files or folders there to process.")
        return
        
    for item in items:
        # Ignore hidden files like .gitkeep or .DS_Store
        if item.name.startswith("."):
            continue
            
        success = process_item(item)
        
        if success:
            dest = PROCESSED_DIR / item.name
            
            # Remove destination if it already exists to overwrite
            if dest.exists():
                if dest.is_dir():
                    shutil.rmtree(dest)
                else:
                    dest.unlink()
                    
            shutil.move(str(item), str(PROCESSED_DIR))
            print(f"  -> Moved to processed/{item.name}")
            
    print("\nProcessing complete.")

if __name__ == "__main__":
    main()
