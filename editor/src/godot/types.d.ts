type GodotWindow = Window & {
    onIpcMessage?: (msg: string) => unknown,
    sendIpcMessage?: (msg: string) => unknown,
}