import { BaseApp } from "../base/types";
import { TextEditAppComponent } from "./components/TextEditAppComponent";

export const helpItems = [
  {
    icon: "📝",
    title: "Rich Editing",
    description: "Type, copy, cut, paste, undo & redo your text with ease",
  },
  {
    icon: "🎨",
    title: "Formatting",
    description: "Bold, italic, underline, headings & alignment options",
  },
  {
    icon: "📋",
    title: "Lists & Tasks",
    description: "Create bullet, numbered & check-box task lists",
  },
  {
    icon: "💾",
    title: "File Management",
    description:
      "Create, open, save, and export files (HTML, MD, TXT) with auto-save",
  },
  {
    icon: "🎤",
    title: "Voice Dictation",
    description: "Dictate text hands-free right into the document",
  },
  {
    icon: "⚡",
    title: "Slash Commands",
    description: "Type / for quick actions or let Heide AI edit lines remotely",
  },
];

export const appMetadata = {
  name: "TextEdit",
  version: "1.0",
  creator: {
    name: "Mathias Heide",
    url: "https://heide.ai",
  },
  github: "https://github.com/mathias-heide/heide",
  icon: "/icons/default/textedit.png",
};

export const TextEditApp: BaseApp = {
  id: "textedit",
  name: "TextEdit",
  icon: { type: "image", src: appMetadata.icon },
  description: "A simple rich text editor",
  component: TextEditAppComponent,
  helpItems,
  metadata: appMetadata,
};
