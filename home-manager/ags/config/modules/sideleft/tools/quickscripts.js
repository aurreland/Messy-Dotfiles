const { Gtk } = imports.gi;
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { execAsync, exec } = Utils;
const { Box, Button, EventBox, Icon, Label, Scrollable } = Widget;
import SidebarModule from './module.js';
import { MaterialIcon } from '../../.commonwidgets/materialicon.js';
import { setupCursorHover } from '../../.widgetutils/cursorhover.js';

import { distroID, isArchDistro, isDebianDistro, hasFlatpak } from '../../.miscutils/system.js';

const scripts = [
    {
        icon: 'nixos-symbolic',
        name: 'Rebuild System Configuration',
        command: `sudo hera -s system`,
        enabled: distroID == 'nixos',
    },
    {
        icon: 'nixos-symbolic',
        name: 'Rebuild User Configuration',
        command: `hera -s user`,
        enabled: distroID == 'nixos',
    },
    {
        icon: 'nixos-symbolic',
        name: 'Upgrade Configuration',
        command: `sudo hera -U`,
        enabled: distroID == 'nixos',
    },
    {
        icon: 'ubuntu-symbolic',
        name: 'Update packages',
        command: `sudo apt update && sudo apt upgrade -y`,
        enabled: isDebianDistro,
    },
    {
        icon: 'fedora-symbolic',
        name: 'Update packages',
        command: `sudo dnf upgrade -y`,
        enabled: distroID == 'fedora',
    },
    {
        icon: 'arch-symbolic',
        name: 'Update packages',
        command: `sudo pacman -Syyu`,
        enabled: isArchDistro,
    },
    {
        icon: 'arch-symbolic',
        name: 'Remove orphan packages',
        command: `sudo pacman -R $(pacman -Qdtq)`,
        enabled: isArchDistro,
    },
    {
        icon: 'flatpak-symbolic',
        name: 'Uninstall unused flatpak packages',
        command: `flatpak uninstall --unused`,
        enabled: hasFlatpak,
    },
];

export default () => SidebarModule({
    icon: MaterialIcon('code', 'norm'),
    name: 'Quick scripts',
    child: Box({
        vertical: true,
        className: 'spacing-v-5',
        children: scripts.map((script) => {
            if (!script.enabled) return null;
            const scriptStateIcon = MaterialIcon('not_started', 'norm');
            return Box({
                className: 'spacing-h-5 txt',
                children: [
                    Icon({
                        className: 'sidebar-module-btn-icon txt-large',
                        icon: script.icon,
                    }),
                    Label({
                        className: 'txt-small',
                        hpack: 'start',
                        hexpand: true,
                        label: script.name,
                        tooltipText: script.command,
                    }),
                    Button({
                        className: 'sidebar-module-scripts-button',
                        child: scriptStateIcon,
                        onClicked: () => {
                            closeEverything();
                            execAsync([`bash`, `-c`, `${userOptions.apps.terminal} fish -C "${script.command}"`]).catch(print)
                                .then(() => {
                                    scriptStateIcon.label = 'done';
                                })
                        },
                        setup: setupCursorHover,
                    }),
                ],
            })
        }),
    })
});
