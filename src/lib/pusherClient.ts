import Pusher, { Channel } from "pusher-js";

// App-wide singleton so we don't open/close the WebSocket on every React Strict-Mode remount.

const globalWithPusher = globalThis as typeof globalThis & {
  __pusherClient?: Pusher;
};

const PUSHER_APP_KEY = import.meta.env.VITE_PUSHER_KEY;
const PUSHER_CLUSTER = import.meta.env.VITE_PUSHER_CLUSTER;

export function getPusherClient(): Pusher {
  if (!globalWithPusher.__pusherClient) {
    // Check if Pusher keys are available
    if (!PUSHER_APP_KEY || !PUSHER_CLUSTER) {
      console.warn('Pusher keys not found in environment. Chat features will be disabled.');
      console.log('VITE_PUSHER_KEY:', PUSHER_APP_KEY || 'undefined');
      console.log('VITE_PUSHER_CLUSTER:', PUSHER_CLUSTER || 'undefined');
      // Return a mock Pusher client that doesn't crash
      return {
        subscribe: () => ({ bind: () => {}, unbind: () => {} }),
        unsubscribe: () => {},
        disconnect: () => {},
      } as any;
    }
    
    // Create once and cache
    globalWithPusher.__pusherClient = new Pusher(PUSHER_APP_KEY, {
      cluster: PUSHER_CLUSTER,
      forceTLS: true,
    });
  }
  return globalWithPusher.__pusherClient;
}

export type PusherChannel = Channel;
