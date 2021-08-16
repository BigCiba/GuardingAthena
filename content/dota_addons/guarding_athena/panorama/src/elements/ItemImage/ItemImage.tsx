import React from 'react';
import classNames from 'classnames';
import { DOTAItemImageAttributes, PanelAttributes } from '@demon673/react-panorama';

let borderStyles: Record<number, Partial<VCSSStyleDeclaration>> = {
	0: {
		width: "100%", height: "100%",
		border: "1px solid #BEBEBE",
	},
	1: {
		width: "100%", height: "100%",
		border: "1px solid #92E47E",
	},
	2: {
		width: "100%", height: "100%",
		border: "1px solid #7F93FC",
	},
	3: {
		width: "100%", height: "100%",
		border: "1px solid #D57BFF",
	},
	4: {
		width: "100%", height: "100%",
		border: "1px solid #FFE195",
	},
	5: {
		width: "100%", height: "100%",
		border: "1px solid #FF9595",
	},
};

export function CustomItemImage({ className, itemname, contextEntityIndex, showtooltip = true, src, scaling, ...other }: DOTAItemImageAttributes) {
	let a = { ...other } as PanelAttributes;
	let b: DOTAItemImageAttributes = {};
	let iNeutralTier = -1;
	if (itemname) {
		iNeutralTier = GetItemRarity(itemname);
		b.itemname = itemname;
	}
	if (contextEntityIndex) {
		iNeutralTier = GetItemRarity(Abilities.GetAbilityName(contextEntityIndex));
		b.contextEntityIndex = contextEntityIndex;
	}
	if (src) {
		b.src = src;
	}
	if (scaling) {
		b.scaling = scaling;
	}
	return (
		<Panel className={classNames("CustomItemImage", className)} {...a}>
			<DOTAItemImage id="CustomItemImage" key={"DOTAItemImage"} {...b} showtooltip={false} style={{ width: "100%", height: "100%" }} />
			<Panel id="CustomItemImageBorder" style={borderStyles[iNeutralTier]} />
		</Panel>
	);
}


export function CustomItemImageFragments({ itemname, contextEntityIndex, src, scaling }: { itemname?: string, contextEntityIndex?: ItemEntityIndex, src?: string, scaling?: ScalingFunction; }) {
	let b: DOTAItemImageAttributes = {};
	let iNeutralTier = -1;
	if (itemname) {
		iNeutralTier = GetItemRarity(itemname);
		b.itemname = itemname;
	}
	if (contextEntityIndex) {
		iNeutralTier = GetItemRarity(Abilities.GetAbilityName(contextEntityIndex));
		b.contextEntityIndex = contextEntityIndex;
	}
	if (src) {
		b.src = src;
	}
	if (scaling) {
		b.scaling = scaling;
	}
	return (
		<>
			<DOTAItemImage key={"DOTAItemImage"} {...b} showtooltip={false} style={{ width: "100%", height: "100%" }} />
			<Panel id="CustomItemImageBorder" style={borderStyles[iNeutralTier]} />
		</>
	);
}