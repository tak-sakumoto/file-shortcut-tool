# file-shortcut-tool

## Introduction

This repository provides a tool for creating shortcuts to file paths listed in a specified CSV file.

## Usage

### Command

```plaintxt
> .\main.ps1 -listPath .\list.csv -defaultParent \path\to\default_folder
```

### Arguments

| Argument | Required | Default | Explanation |
|-|:-:|-|-|
| `-listPath \<path>` | o | - | A path to a list CSV file that describes the targets of the shortcut creation |
| `-defaultParent \<path>` | x | `.\` | A default path to save shortcuts |

### List (CSV)

```csv
Path,Parent,Name
\path\to\file_A,\path\to\folder_B,
\path\to\folder_C,,Folder_C
```

If the CSV file specified by `-listPath` is described as above,

- the shortcut for `\path\to\file_A` will be named `file_A` and placed in `\path\to\folder_B`.
- the shortcut for `\path\to\folder_C` will be named `Folder_C` and saved in the location specified by `-defaultParent`.

## Author

[Takuya Sakumoto (作元 卓也)](https://github.com/tak-sakumoto)
