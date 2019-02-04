Pet = class(
    {
        -- property
        unitHandle;
        quality = 0;
        lv = 1;
        -- ai
        aiState = "idle";
        aiStateRate = {
            idle = 30;
            move = 30;
            attack = 20;
            cast = 20;
        }
        constructor = function (self, unitHandle, quality, lv)
            self.unitHandle = unitHandle or self.unitHandle
            self.quality = quality or self.quality
            self.lv = lv or self.lv

            self.unitHandle:SetLevel(self.lv)
        end;

        GetState = function ( self )
            return self.aiState
        end;
    },
    {
        __class__name = "Pet"
    },
    nil
)