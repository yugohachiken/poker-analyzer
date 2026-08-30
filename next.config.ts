import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: {
    serverActions: {
      // The browser's actual `origin` header is localhost:3000 in this
      // setup (Codespaces/VS Code port forwarding keeps requests pointed
      // at localhost even though the displayed URL is a *.app.github.dev
      // address), while `x-forwarded-host` is the github.dev domain. The
      // mismatch between those two triggers Next.js's CSRF check, so we
      // allow the actual origin explicitly.
      allowedOrigins: ["localhost:3000", "*.app.github.dev"],
    },
  },
};

export default nextConfig;
