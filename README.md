# Police Radio UI for FiveM

A sleek, futuristic police radio user interface for FiveM servers integrated with PMA-Voice and FivePD.  
This resource lets on-duty FivePD officers join and leave voice radio channels through an easy-to-use UI, toggleable with F3, complete with radio talking animations and sound effects.

---

## Features

- **Toggleable UI:** Press **F3** to open or close the radio UI.  
- **Channel Join/Leave:** Enter a channel number (1–999) and join or leave the radio channel.  
- **Authorization:** Only on-duty FivePD officers can access and use the radio UI.  
- **Radio Animations & Sounds:** Player performs radio animations and hear click sounds while talking.  
- **Cursor Management:** Cursor automatically shows when UI is open and hides when closed.  
- **Real-time Status Messages:** Displays join/leave status and validation errors in the UI.

---

## Installation

1. Clone or download this resource into your FiveM `resources` folder.  
2. Add `start your-resource-name` to your `server.cfg`.  
3. Ensure your server is running **pma-voice** and **FivePD** resources for full functionality.

---

## Usage

- Press **F3** in-game to toggle the police radio UI.  
- If you are an authorized FivePD officer (on-duty), the UI will open and allow you to enter a radio channel number.  
- Click **Join Channel** to connect to that radio frequency via PMA-Voice.  
- Click **Leave Channel** to disconnect from the current channel.  
- Click **Close** to close the radio UI and hide your mouse cursor.  
- When you speak on the radio, your character performs radio animations and you hear a radio click sound.

---

## Files

- `client.lua` — Handles UI toggle, authorization check with server, NUI callbacks, radio animations, and communication with PMA-Voice.  
- `html/index.html` — The radio UI frontend with modern styling and JavaScript for UI logic and communication with the client script.

---

## Customization

- Adjust UI appearance by editing the CSS inside `index.html`.  
- Modify animations or sound effects in `client.lua`.  
- Change authorized roles or departments in your server-side scripts to fit your FivePD setup.

---

## Dependencies

- [pma-voice](https://github.com/ToasterSrv/pma-voice) — Voice communication resource  
- [FivePD](https://github.com/JP0HN/FivePD) — Police roleplay framework  

---

## License

MIT License — feel free to modify and use as you like in your FiveM projects.

---

If you want help generating full scripts or folder structures, just ask!
