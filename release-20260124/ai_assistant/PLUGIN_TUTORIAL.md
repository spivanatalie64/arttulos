# Tutorial: Writing a Plugin for the AI Assistant

1. Create a new plugin file in `ai_assistant/plugins/`, e.g. `my_plugin.scrapec`.
2. Implement the required interface:
   ```scrapec
   fn run(args: Vec<String>) -> String {
       // Your plugin logic here
       "Hello from my_plugin!".to_string()
   }
   ```
3. Add a JSON manifest `my_plugin.json`:
   ```json
   {
     "name": "my_plugin",
     "description": "A sample plugin.",
     "entry": "my_plugin.scrapec"
   }
   ```
4. Test your plugin:
   ```sh
   ./main.scrapec plugins run my_plugin
   ```
5. See `PLUGIN_SYSTEM.md` for advanced features.
