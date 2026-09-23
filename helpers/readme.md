# Lua Helpers ([Voxrame](https://voxrame.dev) component)
[![Maintained By: Lord Team](https://img.shields.io/badge/Maintained%20By-Lord%20Team-659b4b?style=for-the-badge)](https://github.com/lord-server/lord?tab=readme-ov-file#contributors--%D1%83%D1%87%D0%B0%D1%81%D1%82%D0%BD%D0%B8%D0%BA%D0%B8)
[![Donate: Boosty](https://img.shields.io/badge/Donate-Boosty-f15f2c?style=for-the-badge)](https://boosty.to/lord-server)
[![License: MIT](https://img.shields.io/badge/License-MIT-444?style=for-the-badge)](./license.md)

---

## Detailed documentation:

- 🇺🇸 [English](https://voxrame.dev/utils/helpers)
- 🇷🇺 [Русский](https://voxrame.dev/ru/utils/helpers)
- 🇩🇪 [Deutsch](https://voxrame.dev/de/utils/helpers)
- 🇧🇷 [Brasileiro](https://voxrame.dev/br/utils/helpers)
- 🇨🇳 [中文](https://voxrame.dev/zh/utils/helpers)
- 🇪🇸 [Español](https://voxrame.dev/es/utils/helpers)
- 🇫🇷 [Français](https://voxrame.dev/fr/utils/helpers)
- 🇮🇹 [Italiano](https://voxrame.dev/it/utils/helpers)
- 🇵🇱 [Polski](https://voxrame.dev/pl/utils/helpers)
- 🇮🇩 [Indonesia](https://voxrame.dev/id/utils/helpers)
- 🇹🇷 [Türkçe](https://voxrame.dev/tr/utils/helpers)
- 🇸🇦 [العربية](https://voxrame.dev/ar/utils/helpers)
- 🇻🇳 [Tiếng Việt](https://voxrame.dev/vi/utils/helpers)

---

<p align="center">
   Made with ❤️ for the Luanti community<br>
   © 2026 Lord Team
</p>

---

## Overview

### [String](https://voxrame.dev/utils/helpers#string)

<table>
<tr valign="top">
<td>

[`string:lower()`](https://voxrame.dev/utils/helpers#string-lower)  
[`string:upper()`](https://voxrame.dev/utils/helpers#string-upper)  
[`string:is_one_of()`](https://voxrame.dev/utils/helpers#string-is-one-of-table)  
[`string:first_to_upper()`](https://voxrame.dev/utils/helpers#string-first-to-upper)  
[`string:title()`/`:to_headline()`](https://voxrame.dev/utils/helpers#string-title-to-headline)  
[`string:starts_with()`](https://voxrame.dev/utils/helpers#string-starts-with-prefix)  
[`string:ends_with()`](https://voxrame.dev/utils/helpers#string-ends-with-suffix)  

</td>
<td>

[`string:contains()`](https://voxrame.dev/utils/helpers#string-contains-sub-string)  
[`string:replace()`](https://voxrame.dev/utils/helpers#string-replace-pattern-replacement-n)  
[`string:remove()`](https://voxrame.dev/utils/helpers#string-remove-pattern-n)  
[`string:reg_escape()`](https://voxrame.dev/utils/helpers#string-reg-escape)  
[`string:vxr_split()`](https://voxrame.dev/utils/helpers#string-vxr-split-delimiter-processor)  
[`string.or_nil()`](https://voxrame.dev/utils/helpers#string-or-nil-value)  

</td>
</tr>
</table>

### [Table](https://voxrame.dev/utils/helpers#table)

<table>
<tr valign="top">
<td>

[`table.keys()`](https://voxrame.dev/utils/helpers#table-keys-table)  
[`table.values()`](https://voxrame.dev/utils/helpers#table-values-table)  
[`table.has_key()`](https://voxrame.dev/utils/helpers#table-has-key-table-key)  
[`table.contains`/`.has_value()`](https://voxrame.dev/utils/helpers#table-contains-has-value-table-value)  
[`table.keys_of()`](https://voxrame.dev/utils/helpers#table-keys-of-table-value)  
[`table.has_any_key()`](https://voxrame.dev/utils/helpers#table-has-any-key-table-find-keys)  
[`table.equals()`](https://voxrame.dev/utils/helpers#table-equals-table1-table2)  
[`table.is_empty()`](https://voxrame.dev/utils/helpers#table-is-empty-table)  
[`table.is_position()`](https://voxrame.dev/utils/helpers#table-is-position-table)  
[`table.each_value_is()`](https://voxrame.dev/utils/helpers#table-each-value-is-table-value)  
[`table.count()`](https://voxrame.dev/utils/helpers#table-count-table)  
[`table.generate_sequence()`](https://voxrame.dev/utils/helpers#table-generate-sequence-max-start-from-step)  

</td>
<td>

[`table.only()`](https://voxrame.dev/utils/helpers#table-only-table-only)  
[`table.except()`](https://voxrame.dev/utils/helpers#table-except-table-keys)  
[`table.merge()`](https://voxrame.dev/utils/helpers#table-merge-table1-table2-overwrite)  
[`table.join()`](https://voxrame.dev/utils/helpers#table-join-table1-table2-recursively)  
[`table.overwrite()`](https://voxrame.dev/utils/helpers#table-overwrite-table1-table2)  
[`table.merge_values()`](https://voxrame.dev/utils/helpers#table-merge-values-table1-table2)  
[`table.map()`](https://voxrame.dev/utils/helpers#table-map-table-callback-overwrite)  
[`table.walk()`/`.each()`](https://voxrame.dev/utils/helpers#table-walk-each-table-callback)  
[`table.multiply_each_value()`](https://voxrame.dev/utils/helpers#table-multiply-each-value-table-multiplier-table)  
[`table.add_values()`](https://voxrame.dev/utils/helpers#table-add-values-table1-table2-empty-value-overwrite)  
[`table.sub_values()`](https://voxrame.dev/utils/helpers#table-sub-values-table1-table2-empty-value-overwrite)  
[`table.mul_values()`](https://voxrame.dev/utils/helpers#table-mul-values-table1-table2-empty-value-overwrite)  
[`table.div_values()`](https://voxrame.dev/utils/helpers#table-div-values-table1-table2-empty-value-overwrite)  

</td>
</tr>
</table>

### [Math](https://voxrame.dev/utils/helpers#math)

<table>
<tr valign="top">
<td>

[`math.limit`/`clamp()`](https://voxrame.dev/utils/helpers#math-limit-clamp-value-min-max)  
[`math.is_within()`](https://voxrame.dev/utils/helpers#math-is-within-value-min-max)  
[`math.is_among()`](https://voxrame.dev/utils/helpers#math-is-among-value-min-max)  
[`math.is_in_range()`](https://voxrame.dev/utils/helpers#math-is-in-range-value-min-max)  
[`math.is_near()`](https://voxrame.dev/utils/helpers#math-is-near-value-near-gap)  

</td>
<td>

[`math.quadratic_equation_roots()`](https://voxrame.dev/utils/helpers#math-quadratic-equation-roots-a-b-c)  
[`math.point_on_circle()`](https://voxrame.dev/utils/helpers#math-point-on-circle-radius-angle)  

</td>
</tr>
</table>

### [Debug](https://voxrame.dev/utils/helpers#debug)

<table>
<tr valign="top">
<td>

[`__FILE__()`](https://voxrame.dev/utils/helpers#file-depth-full)  
[`__LINE__()`](https://voxrame.dev/utils/helpers#line-depth)  
[`__FILE_LINE__()`](https://voxrame.dev/utils/helpers#file-line-depth-full)  
[`__DIR__()`](https://voxrame.dev/utils/helpers#dir-depth)  
[`__FUNC__()`](https://voxrame.dev/utils/helpers#func-depth)  
[`print_dump()`](https://voxrame.dev/utils/helpers#print-dump-depth-with-trace) / [`pd()`](https://voxrame.dev/utils/helpers#pd) / [`pdt()`](https://voxrame.dev/utils/helpers#pdt)  

</td>
<td>

[`debug.get_stack_frames()`](https://voxrame.dev/utils/helpers#debug-get-stack-frames-depth)  
[`debug.render_backtrace()`](https://voxrame.dev/utils/helpers#debug-render-backtrace-frames-plain)  
[`debug.print_backtrace()`](https://voxrame.dev/utils/helpers#debug-print-backtrace-frames)  
[`debug.measure()`](https://voxrame.dev/utils/helpers#debug-measure-name-callback-print-result)  
[`debug.measure_print()`](https://voxrame.dev/utils/helpers#debug-measure-print-name)  

</td>
</tr>
</table>

### [Exception](https://voxrame.dev/utils/helpers#exception)

[`exception.try()`](https://voxrame.dev/utils/helpers#exception-try-callback)  
[`:catch()`](https://voxrame.dev/utils/helpers#catch-handler)  

### [Global](https://voxrame.dev/utils/helpers#global)

[`errorf()`](https://voxrame.dev/utils/helpers#errorf-message)  
[`errorlf()`](https://voxrame.dev/utils/helpers#errorlf-message-level)  
[`assertf()`](https://voxrame.dev/utils/helpers#assertf-condition-message)  

### [IO](https://voxrame.dev/utils/helpers#io)

<table>
<tr valign="top">
<td>

[`io.file_exists()`](https://voxrame.dev/utils/helpers#io-file-exists-name)  
[`io.dirname()`](https://voxrame.dev/utils/helpers#io-dirname-path)  

</td>
<td>

[`io.write_to_file()`](https://voxrame.dev/utils/helpers#io-write-to-file-filepath-content-mode)  
[`io.read_from_file()`](https://voxrame.dev/utils/helpers#io-read-from-file-filepath-mode)  
[`io.get_file_error()`](https://voxrame.dev/utils/helpers#io-get-file-error)  

</td>
</tr>
</table>

### [OS](https://voxrame.dev/utils/helpers#os)

[`os.DIRECTORY_SEPARATOR`](https://voxrame.dev/utils/helpers#os-directory-separator)  

---

## Development

All contributions should be made to the main repository: [https://github.com/Voxrame/Voxrame](https://github.com/Voxrame/Voxrame)

## Support

- 🐞 [Report Issues](https://github.com/Voxrame/voxrame/issues)
<!-- - 💬 [Discord Community](https://discord.gg/voxrame) -->
- ❤️ [Support Development](https://boosty.to/lord-server)


## Debug Configure

**Configure clickable file-links for you IDE**

1. Ensure that your [terminal supports ANSI OSC8 Codes](https://github.com/Alhadis/OSC8-Adoption).
2. Configure custom scheme for your OS, examples for Linux:
   - [For IDEA IDEs](#for-idea-ides)
   - [For VsCode](#for-vscode)
   - [For Kate](#for-kate)
3. Enable links in `minetest.conf`:
   - set config setting `debug = true`
   - set config setting `debug.editor_x_scheme_tpl` for your IDE, examples:
     - `debug.editor_x_scheme_tpl = clion://open?file=${file}&line=${line}`
     - `debug.editor_x_scheme_tpl = vscode://file/${file}:${line}?project=${project}`
     - `debug.editor_x_scheme_tpl = kate://open?file=${file}&line=${line}&project=${project}`
   
   Supported variables in scheme template:
   - `${project}` - full path to project
   - `${file}` - full path to file
   - `${file_relative}` - path to file from project root (from `${project}`)
   - `${line}` - line number in the file

### For IDEA IDEs
#### (CLion, PhpStorm, WebStorm, PyCharm,...)
1. Create script `/usr/local/bin/phpstorm-url-handler`:
   ```shell
   #!/usr/bin/env bash

   url="$1"
   file=$(echo "$url" | grep -oP 'file=\K[^&]+')
   line=$(echo "$url" | grep -oP 'line=\K[0-9]+')
   project=$(echo "$url" | grep -oP 'project=\K[^&]+')

   phpstorm --line "$line" "$file"
   ```
   and make it executable:
   ```shell
   chmod +x /usr/local/bin/phpstorm-url-handler
   ```
2. Create file `~/.local/share/applications/phpstorm-url-handler.desktop`
   ```
   [Desktop Entry]
   Name=PhpStorm URL Handler
   Exec=phpstorm-url-handler %u
   #Icon=phpstorm
   Type=Application
   Categories=Development
   MimeType=x-scheme-handler/phpstorm
   ```

### For VsCode
VsCode supports urls out of the box.  
It usually places its `.desktop`-file in `/usr/share/applications/code.desktop`.

If your project(contains) relative path or `~/`, VsCode considers this to be different path than the full path.
And VsCode opens the file you clicked as an external file and does not associate with the project.  
In this case you can just change your scheme template in `minetest.conf` like this:
```
debug.editor_x_scheme_tpl = vscode://file/${file}:${line}?project=~/<path>/<to>/<project>
```

### For Kate
1. Create script `/usr/local/bin/kate-url-handler`:
   ```shell
   #!/usr/bin/env bash

   url="$1"
   file=$(echo "$url" | grep -oP 'file=\K[^&]+')
   line=$(echo "$url" | grep -oP 'line=\K[0-9]+')
   project=$(echo "$url" | grep -oP 'project=\K[^&]+')

   kate --line "$line" -s "$project" "$file"
   ```
   and make it executable:
   ```shell
   chmod +x /usr/local/bin/kate-url-handler
   ```
2. Create file `~/.local/share/applications/kate-url-handler.desktop`
   ```
   [Desktop Entry]
   Name=Kate URL Handler
   Exec=kate-url-handler %u
   Icon=kate
   Type=Application
   Categories=Development
   MimeType=x-scheme-handler/kate
   ```
3. Register scheme `kate://`
   ```shell
   xdg-mime default kate-url-handler.desktop x-scheme-handler/kate
   update-desktop-database ~/.local/share/applications
   ```
4. Test:
   ```shell
   xdg-open 'kate://open?file=/path/to/project/file&line=42&project='
   ```
5. Don't forget to configure your scheme template in `minetest.conf` (see above).
