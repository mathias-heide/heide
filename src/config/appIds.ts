export const appIds = [
  "finder",
  "internet-explorer",
  "chats",
  "textedit",
  "paint",
  "minesweeper",
  "videos",
  "ipod",
  "synth",
  "pc",
  "control-panels",
] as const;

export type AppId = typeof appIds[number]; 