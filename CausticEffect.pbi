; CausticWater -  
; https://www.purebasic.fr/french/viewtopic.php?t=14928
;
; Télécharger un générateur de textures caustics
; https://www.cathalmcnally.com/news/free-caustics-generator/

DeclareModule CausticWater
  Declare CreateGroupMaterial(Material, GenericFile.s, NumberOfFrames.i, Blend.i = 255, Culling.b = #False)
  Declare SetEntityGroupMaterial(Entity, Material)
  Declare UpdateGroupMaterial(Entity, Timer = 15)
EndDeclareModule

Module CausticWater
  ;-Private  
  Structure NewMaterial
    Array Materials.i(0)
    Index.i
    Time.i
  EndStructure
  Global NewMap CausticMaterials.NewMaterial()
  
  Structure NewUpdate
    material.i
    index.i
    time.i
  EndStructure
  Global NewMap Updates.NewUpdate()
  
  Global MaterialEnum
  
  ;-Public Area 
  Procedure CreateGroupMaterial(Material, GenericFile.s, NumberOfFrames.i, Blend.i = 255, Culling.b = #False)
    Protected Buffer.s = GetFilePart(GenericFile, #PB_FileSystem_NoExtension)
    Protected GenericFileName.s = Left(Buffer, Len(Buffer)-1)
    Protected Texture
    Protected n
    
    If Material = #PB_Any 
      Material = MaterialEnum
      MaterialEnum + 1
    EndIf
      
    AddMapElement(CausticMaterials(), Str(Material))
    
    For n=0 To NumberOfFrames-1
      Texture = LoadTexture(#PB_Any, GenericFileName + "_"+RSet(Str(n+1), 3, "0") +"."+ GetExtensionPart(GenericFile))
      CausticMaterials()\Materials(n) = CreateMaterial(#PB_Any, TextureID(Texture))
                  
      If Blend < 255
        MaterialBlendingMode(CausticMaterials()\Materials(n), #PB_Material_AlphaBlend)
        SetMaterialColor(CausticMaterials()\Materials(n), #PB_Material_DiffuseColor, RGBA(255, 255, 255, Blend))
      EndIf
      
      If Culling = #True     
        MaterialCullingMode(CausticMaterials()\Materials(n), #PB_Material_NoCulling)
      EndIf
      ReDim CausticMaterials()\Materials(n+1)
    Next
    ProcedureReturn Material
  EndProcedure

  Procedure SetEntityGroupMaterial(Entity, Material)
    AddMapElement(Updates(), Str(Entity))
    With Updates()
      \material = Material
    EndWith
  EndProcedure
  
  Procedure UpdateGroupMaterial(Entity, Timer = 15)
    FindMapElement(Updates(), Str(Entity))
    FindMapElement(CausticMaterials(), Str(Updates()\Material))
    
    Updates()\Time + 1
    If Updates()\Time > Timer
      Updates()\Time = 0
      
      SetEntityMaterial(Entity, MaterialID(CausticMaterials()\Materials(Updates()\index)))
      Updates()\index + 1
      If Updates()\index > ArraySize(CausticMaterials()\Materials())-1
        Updates()\index = 0
      EndIf
    EndIf
  EndProcedure
EndModule
; IDE Options = PureBasic 6.01 LTS beta 2 (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; EnableUnicode