# Forms

Spectra form components are **native HTML inputs** with **light, token-driven styling**.

Validation, state, and logic belong to your application — not the framework.

---

## Core Pattern

All form controls share the same structure:

```html
<div class="sp-field">
  <!-- control -->
  <div class="sp-help">Optional helper text</div>
</div>
```

Error state is applied at the field level:

```html
<div class="sp-field sp-field--error">
  …
</div>
```

---

## Text Input

**Classes**
- `.sp-input`
- `.sp-label`
- `.sp-help`

```html
<div class="sp-field">
  <label class="sp-label" for="name">Name</label>
  <input class="sp-input" id="name" type="text">
  <div class="sp-help">Displayed below the input</div>
</div>
```

---

## Textarea

**Class**
- `.sp-textarea`

```html
<textarea class="sp-textarea"></textarea>
```

- Vertical resize only  
- Uses the same tokens as `.sp-input`

---

## Select

**Class**
- `.sp-select`

```html
<select class="sp-select">
  <option>Option</option>
</select>
```

- Native browser select  
- Minimal arrow affordance  
- No JavaScript styling hacks  

---

## Toggles / Checkbox / Radio

**Classes**
- `.sp-switch`
- `.sp-check`
- `.sp-radio`

Use `.sp-control` for alignment:

```html
<div class="sp-field">
  <div class="sp-control">
    <input class="sp-check" type="checkbox" id="remember">
    <label class="sp-label" for="remember">Remember me</label>
  </div>
</div>
```

---

## Groups

Use native `<fieldset>` for grouped inputs:

```html
<fieldset class="sp-fieldset">
  <legend class="sp-legend">Plan</legend>
  …
</fieldset>
```

---

## Rules

- Native inputs only  
- Token-driven styling  
- No JavaScript or ARIA overrides  
- Layout via `.sp-field` and `.sp-control`
