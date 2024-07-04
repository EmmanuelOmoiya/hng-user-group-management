![User and Group Management in Linux](https://miro.medium.com/v2/resize:fit:1400/1*pI94lVONL4p54Lh3icTz6g.png)

# User and Group Management Script

## Overview

The `create_users.sh` script is designed to automate the process of creating users and groups on a Linux system. Given an input file with a list of users and their corresponding groups, the script will:

- Create specified groups if they do not exist.
- Create users and add them to the specified groups.
- Generate a random password for each user and store it securely.
- Log the actions taken during the execution of the script.

## Usage

### Prerequisites

- The script must be run with root privileges.
- Ensure you have the necessary permissions to create users and groups on the system.

### Installation

1. Clone this repository or download the `create_users.sh` script to your local machine.
2. Make the script executable:

    ```bash
    chmod +x create_users.sh
    ```

### Running the Script

1. Prepare an input file with the list of users and their groups. Each line should contain a username followed by a semicolon (`;`) and a comma-separated list of groups. Example:

    ```
    alice;developers,admins
    bob;testers
    carol;developers,testers
    dave;admins
    eve;developers
    ```

2. Run the script with the input file as an argument:

    ```bash
    sudo ./create_users.sh <input_file>
    ```

    Replace `<input_file>` with the path to your input file.

### Script Output

- The script will log its actions to `/var/log/user_management.log`.
- Generated passwords will be stored in `/var/secure/user_passwords.txt`.

## Script Details

### Logging

- The script logs its actions, including the creation of users and groups, to `/var/log/user_management.log`.

### Password Generation

- A random password is generated for each user and stored securely in `/var/secure/user_passwords.txt`.

### Example Input File

Here's an example of an input file:

```
alice;developers,admins
bob;testers
carol;developers,testers
dave;admins
eve;developers
```

### Example Execution

```bash
sudo bash ./create_users.sh users.txt
```

## Error Handling

- The script checks if it is run as root and exits if not.
- It verifies that the input file exists and is readable.
- It handles the creation of users and groups, logging any errors encountered during the process.

## License

This script is provided as-is without any warranty. Use it at your own risk.

## Author

Emmanuel Omoiya - [emmanuelomoiya6@gmail.com](mailto:emmanuelomoiya6@gmail.com) 
[Twitter](https://x.com/Emmanuel_Omoiya)
[Linkedin](https://linkedin.com/in/emmanuelomoiya)
