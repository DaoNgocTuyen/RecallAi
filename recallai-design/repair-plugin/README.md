# RecallAI: organize the existing five screens

This local development plugin is a fallback while Figma MCP reports its Starter-plan call limit. It has **not been run against the live document**, so the requested revision remains pending.

It reuses the five screen IDs from the previous verified design, moves them side by side into **RecallAI – Mobile App Screens**, updates the role-selection subtitle, adds dashboard scroll padding, and focuses the canvas on the screens. It preserves the component library, existing screen content, prototype states, and existing reactions. It creates no network connections and does not delete any nodes.

If any of the five original screens is missing, it stops before editing instead of creating empty replacements. It can be rerun without duplicating its section.

In the Figma desktop app:

1. Open the existing RecallAI file.
2. Use **Plugins → Development → Import plugin from manifest…** and select this folder's `manifest.json`.
3. Run **RecallAI · Organize Existing Mobile Screens**.
4. Visually inspect all five frames and test the existing prototype using Present. Confirm dashboard scrolling and fixed navigation, onboarding steps, login demo states, and role selection.

This plugin performs organization and a small layout correction only. It cannot verify visual fidelity or prototype playback; those checks must happen in Figma. It keeps the existing editable robot illustration. The separately generated 3D PNG is not uploaded.
