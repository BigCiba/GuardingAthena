"use strict";

var pSelf = $.GetContextPanel()

CustomUIConfig.FireForgeParticle = (pTargetPanel, iMaxCount = 1) => {
	let i = pSelf.GetChildCount();
	pSelf.BCreateChildren(`<DOTAParticleScenePanel class="ForgeParticle" particleName="particles/ui/hud/forge.vpcf" particleonly="false" cameraOrigin="-200 -200 282" lookAt="0 0 0" fov="45" hittest="false" />`)
	let pPanel = pSelf.GetChild(i);

	let aPosition = pTargetPanel.GetPositionWithinWindow()
	pPanel.SetPositionInPixels((aPosition.x + pTargetPanel.actuallayoutwidth / 2 - 100) * pPanel.actualuiscale_x, (aPosition.y + pTargetPanel.actuallayoutheight / 2 - 100) * pPanel.actualuiscale_y, 0)

	let iCount = 0;
	let playSound = () => {
		PlaySoundEffect("DOTA_Item.HavocHammer.Cast");
		++iCount;
		if (iCount < iMaxCount) {
			$.Schedule(0.5, playSound)
		}
	}

	$.Schedule(0.2, playSound)

	$.Schedule(0.5*iMaxCount+0.2, () => {
		pPanel.DeleteAsync(-1)
	})
}

CustomUIConfig.FireChangeGold = (pTargetPanel, iChanged, fDuration = 1) => {
	if (iChanged == 0) {
		return;
	}
	let pLabel = $.CreatePanel("Label", pSelf, "");
	pLabel.AddClass("ChangeGold")
	let sText = iChanged.toString();
	if (iChanged < 0) {
		pLabel.AddClass("IsNegetive")
	} else {
		sText = "+" + sText
	}
	pLabel.text = sText;
	pLabel.style.transitionDuration = fDuration + "s"
	pLabel.style.transform = "translateX("+$.RandomInt(-25, 25)+"px)"+ " translateY(-100px)";

	pLabel.AddClass("Popup")

	$.Schedule(0, () => {
		let aPosition = pTargetPanel.GetPositionWithinWindow()
		pLabel.SetPositionInPixels((aPosition.x + pTargetPanel.actuallayoutwidth - pLabel.actuallayoutwidth) * pLabel.actualuiscale_x, (aPosition.y - pLabel.actuallayoutheight / 2) * pLabel.actualuiscale_y, 0)
	})

	$.Schedule(fDuration, () => {
		pLabel.DeleteAsync(1)
	})
}

(() => {
	pSelf.RemoveAndDeleteChildren();
})()