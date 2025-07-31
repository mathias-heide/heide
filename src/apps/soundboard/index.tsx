import { BaseApp } from "../base/types";
import { SoundboardAppComponent } from "./components/SoundboardAppComponent";

export const helpItems = [
  {
    icon: "🎙️",
    title: "Record Slot",
    description: "Click a slot to record audio; click again to stop",
  },
  {
    icon: "▶️",
    title: "Keyboard Play",
    description: "Press 1-9 to trigger sounds instantly",
  },
  {
    icon: "🌊",
    title: "Waveform View",
    description: "See live waveform while recording or playing back",
  },
  {
    icon: "✏️",
    title: "Customize Slot",
    description: "Add emoji & title to each sample for quick ID",
  },
  {
    icon: "📂",
    title: "Multiple Boards",
    description: "Create, rename & switch boards for sets of sounds",
  },
  {
    icon: "🌍",
    title: "Import / Export",
    description: "Share boards as files; drag-drop to import",
  },
];

export const appMetadata = {
  name: "Soundboard",
  version: "0.2",
  creator: {
    name: "Mathias Heide",
    url: "https://heide.ai",
  },
  github: "https://github.com/mathias-heide/heide",
  icon: "/icons/default/cdrom.png",
};

export const SoundboardApp: BaseApp = {
  id: "soundboard",
  name: "Soundboard",
  icon: { type: "image", src: appMetadata.icon },
  description: "A simple soundboard app",
  component: SoundboardAppComponent,
  helpItems,
  metadata: appMetadata,
};
