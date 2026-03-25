# pyproject.toml テンプレート

[project]
name = "[アプリ名]"
version = "0.1.0"
description = "[説明文]"
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
    "customtkinter>=5.2.2",
    "loguru>=0.7.2",
    "pydantic>=2.6.1",
    # "pywin32>=306",  # Excel連携(win32com)使用時に有効化
]

[tool.ruff]
# Ruff の設定：静的解析とフォーマットの自動化
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "W", "N", "UP", "PL"]
ignore = []

[tool.mypy]
# mypy の設定：静的型検査の厳格化
python_version = "3.12"
strict = true
ignore_missing_imports = true
exclude = ["tests/", "temp/"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
