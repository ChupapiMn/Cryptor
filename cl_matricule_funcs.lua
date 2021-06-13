
MATRICULESYSTEMFUNCS = MATRICULESYSTEMFUNCS or {}


surface.CreateFont("MATRICULE:TITLEFONT", {
    font = "Roboto",
    size = ScreenScale(10)
})

surface.CreateFont("MATRICULE:WCM", {
    font = "Roboto",
    size = ScreenScale(12)
})

function MATRICULESYSTEMFUNCS.OpenMatriculeDerma()
    local sw, sh = ScrW(), ScrH()
    local frame = vgui.Create("DFrame")
    frame:SetSize(sw * .22, sh * .3)
    frame:SetDraggable( false )
    frame:SetSizable( false ) 
    frame:ShowCloseButton( false )
    frame:SetTitle("")
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(65, 65, 65))
        draw.RoundedBoxEx(10, 0, 0, w, h * .15, Color(54, 54, 54), true, true)
        draw.SimpleText(MATRICULESYSTEM.ServerName, "MATRICULE:TITLEFONT", w / 2, h * .15 / 2, Color(204, 204, 204), 1, 1)
        draw.SimpleText("Veuillez Choisir un Matricule", "MATRICULE:TITLEFONT", w / 2, h * .22, color_white, 1, 1)
        draw.SimpleText("Ã  " .. MATRICULESYSTEM.MaxNum .. " chiffres.", "MATRICULE:TITLEFONT", w / 2, h * .32, color_white, 1, 1)
        draw.SimpleText(MATRICULESYSTEM.Prefix, "MATRICULE:TITLEFONT", w * .25, h * .42, color_white, TEXT_ALIGN_RIGHT)
        draw.SimpleText("White", "MATRICULE:WCM", w / 2, h - h * .22, color_white, 1)
        draw.SimpleText("Community", "MATRICULE:WCM", w / 2, h - h * .12, color_white, 1)
    end
    
    
    local dte_matricule = frame:Add("DTextEntry")
    dte_matricule:SetSize(sw * .1, sh * .04)
    dte_matricule:SetPos(frame:GetWide() / 2 - dte_matricule:GetWide() / 2, sh * .12)
    dte_matricule:SetFont("MATRICULE:TITLEFONT")
    dte_matricule:SetNumeric( true )
    
    local confirm_btn = frame:Add("DButton")
    confirm_btn:SetSize(sw * .1, sh * .03)
    confirm_btn:SetPos(frame:GetWide() / 2 - confirm_btn:GetWide() / 2, sh * .184)
    confirm_btn:SetText("Confirmer")
    confirm_btn:SetFont("MATRICULE:TITLEFONT")
    confirm_btn:SetTextColor(color_white)
    confirm_btn.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(5, 0, 0, w, h, Color(42, 151, 42))
        else 
            draw.RoundedBox(5, 0, 0, w, h, Color(62, 134, 62))
        end 
    end

    confirm_btn.DoClick = function(self)
        net.Start("MATRICULE:NETS:CHANGENAME") 
        net.WriteUInt(dte_matricule:GetValue(), 32)
        net.SendToServer()
        frame:Close()
    end

    local timer_name = "DTE_" .. dte_matricule:GetFont() .. math.random(0, 1000)
    timer.Create(timer_name, .2, 0, function()
        dte_matricule:SetValue(string.sub(dte_matricule:GetValue(), 0, MATRICULESYSTEM.MaxNum))
    end)

    frame.OnRemove = function()
        timer.Remove(timer_name)
    end

end

concommand.Add("openMatricule", function()
    MATRICULESYSTEMFUNCS.OpenMatriculeDerma()

end)