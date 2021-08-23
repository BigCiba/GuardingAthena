import React, { useEffect, useState, useRef } from 'react';
import { render, useGameEvent, useNetTableKey, useRegisterForUnhandledEvent } from '@demon673/react-panorama';
import classNames from 'classnames';
// import { AbilityPanel } from '../elements/AbilityPanel';
// import { AbilityUpgradeImage } from '../elements/AbilityUpgrade';
// import './stats.js';

function HudMain() {
	return (
		<>
			<Panel id="TopBarRoot">
				{/* <Image className="TopBarBG" /> */}
			</Panel>
		</>
	);

}
render(<HudMain />, $.GetContextPanel());