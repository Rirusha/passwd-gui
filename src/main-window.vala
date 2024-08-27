/* Copyright 2024 Rirusha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

[GtkTemplate (ui = "/io/github/Rirusha/PasswdGUI/ui/main-window.ui")]
public sealed class PasswdGUI.MainWindow: Adw.ApplicationWindow {

    [GtkChild]
    unowned Adw.WindowTitle window_title;
    [GtkChild]
    unowned Adw.StatusPage status_page;
    [GtkChild]
    unowned Adw.PasswordEntryRow passwd_entry;

    const ActionEntry[] ACTION_ENTRIES = {
        { "about", on_about_action },
    };

    public MainWindow (PasswdGUI.Application app) {
        Object (application: app);
    }

    construct {
        add_action_entries (ACTION_ENTRIES, this);
    }

    void on_about_action () {
        var about = new Adw.AboutDialog () {
            application_name = "Passwd GUI",
            application_icon = Config.APP_ID,
            developer_name = "Rirusha",
            version = Config.VERSION,
            // Translators: NAME <EMAIL.COM>
            translator_credits = _("translator-credits"),
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 Rirusha",
            release_notes_version = Config.VERSION
        };

        about.present (this);
    }

    void to_start () {
        
    }
}
