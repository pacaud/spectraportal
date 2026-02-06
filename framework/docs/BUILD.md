# Build / Compile (v0.1)

This project is compiled on the **home desktop** (not on the droplet).
The droplet only hosts static output under `/srv/spectraportal/`.

## What gets uploaded to the droplet
Upload these folders to:
`/srv/spectraportal/framework/`

- `framework/dist/`
- `framework/demos/`
- `framework/docs/`

Do **not** upload:
- `framework/src/`
- `node_modules/`
- `package.json` / lock files
- build configs

## Compile command (home desktop)

Run in your local project folder:

1) Go to the framework folder:
```bash
cd spectraportal/framework
```

2) One-time install (if needed):
```bash
npm i -D postcss postcss-cli postcss-import autoprefixer cssnano
```

3) Compile (production/minified):
```bash
npx postcss src/spectra.css -o https://spectraportal.dev/framework/cdn/v0.1/spectra.css --env production
```

### Optional: dev build (not minified)
```bash
npx postcss src/spectra.css -o https://spectraportal.dev/framework/cdn/v0.1/spectra.css
```

## Quick verify
After compiling, this file should exist:
- `frameworkhttps://spectraportal.dev/framework/cdn/v0.1/spectra.css`

If it starts with lots of CSS rules (and not just `@import ...`), the bundle is good.
