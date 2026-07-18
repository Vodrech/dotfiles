pragma Singleton

import QtQuick

QtObject {
    property color background: "{{ colors.background.default.hex }}"
    property color foreground: "{{ colors.on_background.default.hex }}"

    property color primary: "{{ colors.primary.default.hex }}"
    property color primaryContainer: "{{ colors.primary_container.default.hex }}"
    property color secondary: "{{ colors.secondary.default.hex }}"
    property color secondaryContainer: "{{ colors.secondary_container.default.hex }}"
    property color tertiary: "{{ colors.tertiary.default.hex }}"
    property color tertiaryContainer: "{{ colors.tertiary_container.default.hex }}"

    property color surface: "{{ colors.surface.default.hex }}"
    property color surfaceVariant: "{{ colors.surface_variant.default.hex }}"
    property color outline: "{{ colors.outline.default.hex }}"
}
