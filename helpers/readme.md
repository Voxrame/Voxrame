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
