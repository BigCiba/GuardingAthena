/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/*!*********************************!*\
  !*** ./ui_particles/script.jsx ***!
  \*********************************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements:  */


var pSelf = $.GetContextPanel();

CustomUIConfig.FireForgeParticle = function (pTargetPanel) {
  var iMaxCount = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 1;
  var i = pSelf.GetChildCount();
  pSelf.BCreateChildren("<DOTAParticleScenePanel class=\"ForgeParticle\" particleName=\"particles/ui/hud/forge.vpcf\" particleonly=\"false\" cameraOrigin=\"-200 -200 282\" lookAt=\"0 0 0\" fov=\"45\" hittest=\"false\" />");
  var pPanel = pSelf.GetChild(i);
  var aPosition = pTargetPanel.GetPositionWithinWindow();
  pPanel.SetPositionInPixels((aPosition.x + pTargetPanel.actuallayoutwidth / 2 - 100) * pPanel.actualuiscale_x, (aPosition.y + pTargetPanel.actuallayoutheight / 2 - 100) * pPanel.actualuiscale_y, 0);
  var iCount = 0;

  var playSound = function playSound() {
    PlaySoundEffect("DOTA_Item.HavocHammer.Cast");
    ++iCount;

    if (iCount < iMaxCount) {
      $.Schedule(0.5, playSound);
    }
  };

  $.Schedule(0.2, playSound);
  $.Schedule(0.5 * iMaxCount + 0.2, function () {
    pPanel.DeleteAsync(-1);
  });
};

CustomUIConfig.FireChangeGold = function (pTargetPanel, iChanged) {
  var fDuration = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 1;

  if (iChanged == 0) {
    return;
  }

  var pLabel = $.CreatePanel("Label", pSelf, "");
  pLabel.AddClass("ChangeGold");
  var sText = iChanged.toString();

  if (iChanged < 0) {
    pLabel.AddClass("IsNegetive");
  } else {
    sText = "+" + sText;
  }

  pLabel.text = sText;
  pLabel.style.transitionDuration = fDuration + "s";
  pLabel.style.transform = "translateX(" + $.RandomInt(-25, 25) + "px)" + " translateY(-100px)";
  pLabel.AddClass("Popup");
  $.Schedule(0, function () {
    var aPosition = pTargetPanel.GetPositionWithinWindow();
    pLabel.SetPositionInPixels((aPosition.x + pTargetPanel.actuallayoutwidth - pLabel.actuallayoutwidth) * pLabel.actualuiscale_x, (aPosition.y - pLabel.actuallayoutheight / 2) * pLabel.actualuiscale_y, 0);
  });
  $.Schedule(fDuration, function () {
    pLabel.DeleteAsync(1);
  });
};

(function () {
  pSelf.RemoveAndDeleteChildren();
})();
/******/ })()
;