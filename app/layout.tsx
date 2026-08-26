import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Poker Hand Analyzer",
  description:
    "Upload tournament/SNG hand histories, build range charts, and see how you played.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
