Run FreeRADIUS in docker

---

**Prerequisites:**
- **FreeRADIUS Server:** A working FreeRADIUS server must be pre-installed on your system. This installation should include makefiles and scripts to generate user certificates, which are essential for running a production environment. Without these, user authentication is not possible.
- **User and Group IDs:** The radius user and group must have the ID 970. If this ID differs, you must update it in both the Dockerfile and docker-compose.yml.
- **NAS Key:** Ensure your NAS key is at least 48 characters long to secure communication effectively. Note that this is the minimum value, not the maximum.

**Docker Configuration:**
- The provided Docker compose files import necessary data to enable secure user authentication methods. This way, compromising the FreeRADIUS container will not expose the private CA key.
- **Avoid Debugging in Docker:** Debugging FreeRADIUS within Docker is ineffective and can exacerbate issues.

**Security Practices:**
- **Certificate Rotation:** Rotate the server certificate at least once every 366 days to prevent attackers from impersonating the server to your clients in the event of a breach.
- **Log Directory Permissions:** Set correct permissions for the logging directory `/var/log/radius` to ensure accounting works.

**Our Setup:**
- We use gvisor in systrap mode. KVM can be utilized if it is stable on your system.
- Our configuration does not use RadSec. Instead, the radius server communicates with APs and NASes via VPN tunnels. RadSec can be enabled if supported by your setup.

**License:**
# This Dockerfile is licensed under the MIT License.
# It installs FreeRADIUS, which is licensed under the GPLv2.

---
