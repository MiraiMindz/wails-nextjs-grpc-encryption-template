import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function getRoute(route: string): string {
  if (process.env.NEXT_PUBLIC_ENVIRONMENT === "WAILS") {
      return `${process.env.NEXT_PUBLIC_WAILS_SERVER_ADDRESS}${route}`
  } else {
      return route;
  }
}