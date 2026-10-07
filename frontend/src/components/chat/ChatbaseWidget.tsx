"use client";

import { useEffect } from "react";

const CHATBOT_ID = "hd8Lyw86qVeqVM-ImyeL0";
const EMBED_SRC = "https://www.chatbase.co/embed.min.js";
const EMBED_DOMAIN = "www.chatbase.co";

type ChatbaseFn = ((...args: unknown[]) => unknown) & { q?: unknown[][] };

declare global {
  interface Window {
    chatbase?: ChatbaseFn;
  }
}

function setupQueue() {
  const queue: unknown[][] = [];
  const stub = ((...args: unknown[]) => {
    queue.push(args);
  }) as ChatbaseFn;
  stub.q = queue;
  window.chatbase = stub;
}

function loadEmbed() {
  if (document.getElementById(CHATBOT_ID)) return;
  const script = document.createElement("script");
  script.src = EMBED_SRC;
  script.id = CHATBOT_ID;
  script.setAttribute("domain", EMBED_DOMAIN);
  document.body.appendChild(script);
}

export function ChatbaseWidget() {
  useEffect(() => {
    if (!window.chatbase) setupQueue();
    loadEmbed();
  }, []);

  return null;
}
