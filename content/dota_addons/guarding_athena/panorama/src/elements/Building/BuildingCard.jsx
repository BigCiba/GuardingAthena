import React from 'react';
import classNames from 'classnames';

export function BuildingCard({ buildingName, className, ...other }) {
	return (
		<Panel className={classNames("BuildingCard", className)} {...other}>
			<Label id="BuildingCardName" text={$.Localize(buildingName)} />
		</Panel>
	)
}