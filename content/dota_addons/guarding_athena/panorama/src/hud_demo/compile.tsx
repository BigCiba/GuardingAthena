import React from 'react';

export function Compile({ onload }: { onload: (panel: Panel) => void | undefined }) {
	let init = (element: Panel | null) => {
		if (element != null) {
			element.BLoadLayout("file://{resources}/layout/custom_game/compile.xml", false, false);
		}
	}
	return (
		<Panel id="Compile" ref={init} onload={onload} />
	)
}