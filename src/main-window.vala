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
    unowned Adw.ToastOverlay toast_overlay;
    [GtkChild]
    unowned Gtk.Stack stack;
    [GtkChild]
    unowned Adw.StatusPage status_page;
    [GtkChild]
    unowned Adw.PasswordEntryRow current_passwd_entry;
    [GtkChild]
    unowned Adw.PasswordEntryRow new_passwd_entry;
    [GtkChild]
    unowned Adw.PasswordEntryRow repeat_new_passwd_entry;
    [GtkChild]
    unowned Gtk.Button apply_button;
    [GtkChild]
    unowned Gtk.Button retry_button;

    const ActionEntry[] ACTION_ENTRIES = {
        { "about", on_about_action },
    };

    public MainWindow (PasswdGUI.Application app) {
        Object (application: app);
    }

    construct {
        add_action_entries (ACTION_ENTRIES, this);

        apply_button.clicked.connect (on_apply);
        retry_button.clicked.connect (on_retry);

        current_passwd_entry.changed.connect (check_button_sensitive);
        new_passwd_entry.changed.connect (check_button_sensitive);
        repeat_new_passwd_entry.changed.connect (check_button_sensitive);
    }

    void on_retry () {
        stack.visible_child_name = "main";

        new_passwd_entry.remove_css_class ("error");
        repeat_new_passwd_entry.remove_css_class ("error");

        current_passwd_entry.text = "";
        new_passwd_entry.text = "";
        repeat_new_passwd_entry.text = "";
    }

    void on_apply () {
        if (new_passwd_entry.text != repeat_new_passwd_entry.text) {
            new_passwd_entry.add_css_class ("error");
            repeat_new_passwd_entry.add_css_class ("error");
            toast_overlay.add_toast (new Adw.Toast (_("Passwords don't match")));
            set_focus (new_passwd_entry);
            return;
        }

        stack.visible_child_name = "loading";

        spawn_change_passwd.begin (current_passwd_entry.text, new_passwd_entry.text, (obj, res) => {
            int status_code = spawn_change_passwd.end (res);
            if (status_code == 0) {
                stack.visible_child_name = "success";

            } else {
                toast_overlay.add_toast (new Adw.Toast (_("Wrong current password or new password weak")));
                stack.visible_child_name = "main";
            }
        });
    }

    void check_button_sensitive () {
        apply_button.sensitive = current_passwd_entry.text_length > 0 &&
                                 new_passwd_entry.text_length > 0 &&
                                 repeat_new_passwd_entry.text_length > 0;
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
}
