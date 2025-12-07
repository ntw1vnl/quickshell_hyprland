.pragma library

function isThemeObjValid(jsonObj) {
  const keys = Object.keys(jsonObj);
  const expectedKeys = [
    "name",
    "palette"
  ];
  let allKeysExisting = true;
  for (const key of expectedKeys) {
    if (!keys.includes(key)) {
      console.error(`Missing property ${key} for Theme object`);
      allKeysExisting = false; 
    }
  }
  return allKeysExisting;
}

function isColorPaletteObjValid(jsonObj) {
  const keys = Object.keys(jsonObj);
  const expectedKeys = [
    "bgDark",
    "bg",
    "bgLight",
    "text",
    "textMuted",
    "textDisabled",
    "textDark",
    "green",
    "yellow",
    "red",
    "accent"
  ];
  let allKeysExisting = true;
  for (const key of expectedKeys) {
    if (!keys.includes(key)) {
      console.error(`Missing property ${key} for Palette object`);
      allKeysExisting = false; 
    }
  }
  return allKeysExisting;
}

function createPaletteObj(jsonObj, parent) {
  if (!jsonObj || !isColorPaletteObjValid(jsonObj)) {
    return null;
  }
  const component = Qt.createComponent("../config/ColorPalette.qml");
  const obj = component.createObject(parent, {
    bgDark : jsonObj.bgDark,
    bg: jsonObj.bg,
    bgLight: jsonObj.bgLight,
    text: jsonObj.text,
    textMuted: jsonObj.textMuted,
    textDisabled: jsonObj.textDisabled,
    textDark: jsonObj.textDark,
    green: jsonObj.green,
    yellow: jsonObj.yellow,
    red: jsonObj.red,
    accent: jsonObj.accent
  });
  if (!obj) {
    console.error(`error creating Palette object`);
  }
  return obj;
}

function createThemeObject(jsonObj, parent) {
  if (!jsonObj || !isThemeObjValid(jsonObj) ) {
    return null;
  }
  const component = Qt.createComponent("../config/Theme.qml");
  const obj = component.createObject(parent, {
    name: jsonObj.name
  });
  if (obj == null) {
    console.error("Error creating Theme object");
    return null;
  }
  const palette = createPaletteObj(jsonObj.palette, obj);
  if (!palette) {
    return null;
  }
  obj.palette = palette;
  return obj;
}
