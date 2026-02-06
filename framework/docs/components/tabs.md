# Tabs

Minimal tab set.

Spectra provides the **styles**. Your app (or the demo script) handles toggling `aria-selected` and panel visibility.

## Markup

```html
<div class="sp-tabs" data-tabs>
  <div class="sp-tablist" role="tablist" aria-label="Example tabs">
    <button class="sp-tab is-active" role="tab" aria-selected="true" aria-controls="panel-one" id="tab-one">Overview</button>
    <button class="sp-tab" role="tab" aria-selected="false" aria-controls="panel-two" id="tab-two">Settings</button>
  </div>

  <div class="sp-tabpanel" role="tabpanel" id="panel-one" aria-labelledby="tab-one">
    Overview content
  </div>
  <div class="sp-tabpanel" role="tabpanel" id="panel-two" aria-labelledby="tab-two" hidden>
    Settings content
  </div>
</div>
```

## Demo

See: `framework/demos/tabs.html`

## Accessibility notes

- Each tab is a `button[role="tab"]`.
- Each panel is a `div[role="tabpanel"]`.
- `aria-controls` should match the panel `id`.
- `aria-labelledby` should match the tab `id`.
