# Basic Flutter Shop App

This is an app developed to practice Flutter in my free time, later I will update this README to explain the characteristics included, or you can simply take a look at the git =).

## Getting Started

This app is completely functional at its core, however if you want to try for yourself there are some thing you need to do:

1. Create a firebase project and copy your API key and firebase endpoint as the one in the repository is a just a dummy an not a valid one.

2. Enter into the Authentication opctions in firebase and activate the email authentication method.

3. Configure your firebase Realtime Database with the following rules:

    ```json
    {
      "rules": {
        ".read": "auth != null",
        ".write": "auth != null",
          "products": {
            ".indexOn": ["creatorId"]
          }
      }
    }
    ```

4. Enjoy
