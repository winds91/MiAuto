# app/libs — runtime dependencies (ICCOA CarLink SDK)

## `icar-sdk.dex` — ICCOA CarLink protocol SDK

The ICCOA CarLink protocol is the phone-side transport behind Xiaomi CarWith, OPPO Car+ 车联 and
vivo Jovi InCar. **This file is now tracked in the repository** (`.gitignore` whitelists it via
`!app/libs/icar-sdk.dex`) so a fresh clone builds a projection-capable APK out of the box. It is a
third-party, proprietary bytecode blob, not covered by this project's AGPL-3.0 licence, and
[`injectIccoaDex`](../build.gradle.kts) treats its absence as "build without CarWith support"
rather than as an error.

### Why it needs a build step at all

Gradle/AGP does not consume `.dex` files as dependencies — neither `implementation` nor
`runtimeOnly` will put one into the APK. So the SDK is split in two:

| Half | File | How it is used |
| --- | --- | --- |
| Compile time | [`app/stubs/icar-sdk-stubs.jar`](../stubs) | **Committed.** Signature-only stubs; `compileOnly`, so it never enters the APK. |
| Run time | `app/libs/icar-sdk.dex` | Injected into the packaged APK as the next free `classesN.dex`, then the APK is realigned and re-signed. |

The build then loads every `classesN.dex` through the normal `BaseDexClassLoader` path, so the
SDK classes simply exist at runtime.

### Providing it

Put a file named `icar-sdk.dex` in this directory and build normally. The expected content is
the CarLink SDK dex (currently ~7.1 MB) that implements the `com.share.connect.*` service
surface declared in `app/src/main/AndroidManifest.xml`.

**CI builds with it.** Because the dex is now tracked in git, `actions/checkout` delivers it to
every runner (fork PRs included, which get no secrets but still receive the repository contents),
so `.github/workflows/android-ci.yml` produces CarWith-capable APKs. The "Check for the ICCOA SDK
dex" step stays as a guard: if the file were ever absent it falls back to a compile-only notice
rather than failing the build.

### Do not move the SDK to another package

The SDK is used by cross-process component names and by package names baked into its own
bytecode. Renaming or relocating any of it — including the `com.share.connect`,
`com.easy`, `com.ucar` and `com.ucarsink` package roots — silently breaks the session with
no error message. See [docs/ICCOA_SDK_INTEGRATION.md](../../docs/ICCOA_SDK_INTEGRATION.md)
for the three things that must be ported together with the dex (manifest services, manifest
permissions, and the `androidx.room` runtime dependency).
