# Obsidian Brain — шаблон персональной базы знаний

Готовый шаблон Obsidian-vault с автоматической компиляцией знаний из диалогов с ИИ.

Папка `vault/` содержит полностью настроенный проект: плагины, темы, скрипты, хуки.

---

## Инструкция для LLM-агента (Claude Code / Gemini CLI)

Скопируй следующий промпт и отправь его своему агенту:

> Разверни Obsidian-проект из репозитория https://github.com/Bimo0420/obsidian-brain
>
> **Шаги:**
>
> 1. Клонируй репозиторий во временную папку:
>    ```
>    git clone https://github.com/Bimo0420/obsidian-brain.git _obsidian-brain-tmp
>    ```
>
> 2. Скопируй **всё содержимое** папки `_obsidian-brain-tmp/vault/` (включая скрытые файлы `.obsidian/` и `.gitignore`) в корень текущего проекта:
>    ```
>    cp -r _obsidian-brain-tmp/vault/. .
>    ```
>    На Windows (Git Bash):
>    ```
>    cp -r _obsidian-brain-tmp/vault/. .
>    ```
>    На Windows (PowerShell):
>    ```
>    Copy-Item -Path ".\_obsidian-brain-tmp\vault\*" -Destination "." -Recurse -Force
>    Copy-Item -Path ".\_obsidian-brain-tmp\vault\.obsidian" -Destination "." -Recurse -Force
>    Copy-Item -Path ".\_obsidian-brain-tmp\vault\.gitignore" -Destination ".\.gitignore" -Force
>    ```
>
> 3. Удали временную папку:
>    ```
>    rm -rf _obsidian-brain-tmp
>    ```
>
> 4. Установи Python-зависимости:
>    ```
>    uv sync
>    ```
>
> 5. Настрой хуки для автоматического захвата диалогов.
>    Для **Gemini CLI** — создай `.gemini/settings.json`:
>    ```json
>    {
>      "hooks": {
>        "session_start": ["python", "hooks/session-start.py"],
>        "session_end": ["python", "hooks/session-end.py"],
>        "pre_compact": ["python", "hooks/pre-compact.py"]
>      }
>    }
>    ```
>    Для **Claude Code** — создай `.claude/settings.json`:
>    ```json
>    {
>      "hooks": {
>        "SessionStart": [{"command": "python hooks/session-start.py"}],
>        "SessionEnd": [{"command": "python hooks/session-end.py"}],
>        "PreCompact": [{"command": "python hooks/pre-compact.py"}]
>      }
>    }
>    ```
>
> 6. Готово. Открой папку в Obsidian: File → Open Vault → Open folder as vault.
>    При первом запуске включи community-плагины (Trust and Enable).
>
> Подробная техническая документация — в файле `AGENTS.md`.

---

## Что внутри `vault/`

```
vault/
├── .obsidian/              Конфигурация Obsidian (9 плагинов, 9 тем)
├── daily/                  Ежедневные логи из диалогов с ИИ
├── Excalidraw/             Визуальные заметки и диаграммы
├── hooks/                  Хуки автоматического захвата диалогов
│   ├── session-start.py      внедряет контекст базы при старте сессии
│   ├── session-end.py        извлекает знания при завершении сессии
│   └── pre-compact.py        извлекает знания перед сжатием контекста
├── knowledge/              Скомпилированная база знаний
│   ├── concepts/             статьи-концепции
│   ├── connections/          связи между концепциями
│   ├── qa/                   вопросы и ответы
│   ├── index.md              индекс всех статей (вместо RAG)
│   └── log.md                лог обработки
├── processed/              Обработанные внешние материалы
├── raw/                    Сырые материалы для импорта
├── scripts/                Python-скрипты (compile, flush, query, lint)
├── AGENTS.md               Техническая документация для ИИ-агентов
├── README.md               Описание проекта
├── pyproject.toml          Python-зависимости
└── compile.cmd / process.cmd   Короткие команды для Windows
```

## Требования

- [Obsidian](https://obsidian.md/) (десктоп)
- Python 3.12+
- [uv](https://docs.astral.sh/uv/) (менеджер пакетов)
- Gemini CLI или Claude Code (для автоматических хуков)
