/*
 * Copyright (C) 2024 Rirusha
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace PasswdGUI {

    public async int spawn_change_passwd (string current_password, string new_password) {
        int status_code = 0;

        try {
            Pid child_pid;

            string path_to_script = Path.build_filename (
                Config.SCRIPTSDIR,
                "change-passwd.sh"
            );

            Process.spawn_async_with_fds (
                null,
                {
                    "sh",
                    path_to_script,
                    current_password,
                    new_password
                },
                null,
                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD | SpawnFlags.CHILD_INHERITS_STDIN,
                null,
                out child_pid,
                -1,
                stdout.fileno (),
                stderr.fileno ()
            );

            ChildWatch.add (child_pid, (pid, status) => {
                status_code = Process.exit_status (status);
                Process.close_pid (pid);
                Idle.add (spawn_change_passwd.callback);
            });

        } catch (SpawnError e) {
            error (e.message);
        }

        yield;

        return status_code;
    }
}
