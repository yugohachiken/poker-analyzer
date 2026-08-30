export default function CheckEmailPage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-2 p-8 text-center">
      <h1 className="text-xl font-semibold">Check your email</h1>
      <p className="max-w-sm text-sm text-neutral-500">
        We sent you a confirmation link. Click it to finish creating your
        account, then come back and log in.
      </p>
    </main>
  );
}
