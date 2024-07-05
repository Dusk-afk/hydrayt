# HydraYT

HydraYT is a GUI application developed in Flutter that allows users to play YouTube media through Hydra, a Discord bot, on Discord. This project addresses the restriction on playing YouTube songs by integrating YouTube's API to extract audio files for seamless playback via Discord's API.

## Features

- **YouTube Media Playback**: Stream YouTube audio through Discord using Hydra's capabilities.
- **Automatic User Detection**: Automatically identifies the current logged-in Discord user by decrypting the authorization token stored on the device.
- **Native Integration**: Utilizes a native Flutter plugin written in C++ to directly decrypt tokens using the Windows API, enhancing security and functionality.

## Technologies Used

- **Flutter**: Cross-platform framework for developing the GUI application.
- **Discord API**: Integration to facilitate communication and interaction with Discord servers.
- **YouTube API**: Used to extract audio files from YouTube videos for playback.
- **C++ (via Flutter Plugin)**: Developed a native plugin to enhance security and functionality by decrypting Discord authorization tokens.

## Installation

To install HydraYT, follow these steps:

1. Clone the repository: `git clone https://github.com/Dusk-afk/hydrayt.git`
2. Navigate into the project directory: `cd hydrayt`
3. Install dependencies: `flutter pub get`
4. Run the application: `flutter run`

## Usage

1. Launch the application.
2. Log in to Discord and connect Hydra.
3. Use the GUI to search for and play YouTube media through Hydra on Discord.

## Contributing

Contributions to HydraYT are welcome! If you have any ideas, improvements, or bug fixes, please submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- **Flutter Community**: For the cross-platform development framework.
- **Discord Developers**: For the robust API and support.
- **YouTube Developers**: For providing access to media content via APIs.
- **Stack Overflow**: For valuable insights and solutions during development.

## Contact

For any questions or feedback regarding HydraYT, feel free to reach out:

- GitHub Issues: [HydraYT Issues](https://github.com/Dusk-afk/hydrayt/issues)
- Email: piyushsvps@gmail.com

---

Feel free to customize this `README.md` template further based on additional details or specific aspects of your project. It's designed to provide a clear overview of HydraYT, its features, installation instructions, and how others can contribute or get in touch.
