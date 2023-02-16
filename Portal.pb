; 
; Portal version 1.0
;
EnableExplicit
IncludeFile "CausticEffect.pbi"

; Window
Global Window

; Entités
Global Mesh, Material, Entity, Ground, Portal, Door, PortalGround, Water

; Camera
Global Camera, Hight.f, Distance.f = 1

; MaterialCaustic
Global BlueWater, BlackPortal, BlackGround

; Player : Vue à la troisiéme personne 
Global Player, Rotation.f, PlayerSpeed.f

; Initialisation de l'environnement 3D 
InitEngine3D() : InitKeyboard() : InitSprite() : InitMouse()
Window = OpenWindow(#PB_Any, 0, 0, 0, 0, "", #PB_Window_Maximize | #PB_Window_BorderLess)
OpenWindowedScreen(WindowID(Window),0, 0, WindowWidth(Window) , WindowHeight(Window))   
KeyboardMode(#PB_Keyboard_International)

; Localisation des assets
Add3DArchive("Data/skybox/Early_morning.zip", #PB_3DArchive_Zip) 
Add3DArchive("Data/textures", #PB_3DArchive_FileSystem)
Add3DArchive("Data/textures/blue64/", #PB_3DArchive_FileSystem)
Add3DArchive("Data/textures/black32/", #PB_3DArchive_FileSystem)

; Lumiere & ombre
AmbientColor(RGB(184, 184, 184))
CreateLight(#PB_Any, RGB(255, 255, 255), 0, 100, 100)
WorldShadows(#PB_Shadow_Additive)

; Construction des éléments 3D

;- Ciel
Add3DArchive("assets/skybox/Early_morning.zip", #PB_3DArchive_Zip) 
SkyBox("Early_morning.jpg")

;- Sol
Mesh = CreatePlane(#PB_Any, 5, 24, 4, 4, 1, 1)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "Beton1.png")))
ScaleMaterial(Material, 1, 0.1)
Ground = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material)) 
CreateEntityBody(Ground, #PB_Entity_StaticBody, 1, 1, 1)

;-- Effet de Sol
BlackGround = CausticWater::CreateGroupMaterial(2, "black*.bmp", 32, 170)
Mesh = CreatePlane(#PB_Any, 5, 24, 1, 1, 3, 6)
PortalGround = CreateEntity(#PB_Any, MeshID(Mesh), #PB_Material_None)
MoveEntity(PortalGround, 0, 0.02, 0)
CausticWater::SetEntityGroupMaterial(PortalGround, BlackGround)

;- Bordure droite
Mesh = CreateCylinder(#PB_Any, 0.30, 24)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "Beton1.png")))
ScaleMaterial(Material, 1, 0.1)
RotateMaterial(Material, 90, #PB_Material_Fixed) 

Entity = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material))
RotateEntity(Entity, 90, 0, 20)
MoveEntity(Entity, 2.5, 0.15, 0)
CreateEntityBody(Entity, #PB_Entity_StaticBody, 0, 0, 0)

;-- Bordure gauche 
;   Copie de la bordure droite
Entity = CopyEntity(Entity, #PB_Any)
RotateEntity(Entity, 90, 0, -20)
MoveEntity(Entity, -2.5, 0.15, 0)
CreateEntityBody(Entity, #PB_Entity_StaticBody, 0, 0, 0)

;-- Bordure arriére
Mesh = CreateCylinder(#PB_Any, 0.30, 5.5)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "Beton1.png")))
ScaleMaterial(Material, 1, 0.25)
Entity = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material))
RotateEntity(Entity, 0, -45, 90)
MoveEntity(Entity, 0, 0.15, 12)
CreateEntityBody(Entity, #PB_Entity_StaticBody, 0, 0, 0)

;-- Portail
Mesh = CreateTube(#PB_Any, 4, 3, 0.5)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "symbols.jpg")))
ScaleMaterial(Material, 0.5, 1)
Portal = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material))
RotateEntity(Portal, 90, 0, 90)
MoveEntity(Portal, 0, 2.5, 0)
CreateEntityBody(Portal, #PB_Entity_StaticBody, 1, 1, 1)

;-- Porte du portail avec une texture caustic
BlackPortal = CausticWater::CreateGroupMaterial(#PB_Any, "black*.bmp", 32)
Mesh = CreateCylinder(#PB_Any, 3, 0.3)
Door = CreateEntity(#PB_Any, MeshID(Mesh), #PB_Material_None)
CausticWater::SetEntityGroupMaterial(Door, BlackPortal)
RotateEntity(Door, 90, 0, 90)
MoveEntity(Door, 0, 2.5, 0)

;- Bassin
Mesh = CreateTube(#PB_Any, 4, 3.5, 3, 4, 1)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "beton1.png")))
ScaleMaterial(Material, 0.5, 1)
Entity = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material))
MoveEntity(Entity, 0, -1, -14.8)
RotateEntity(Entity, 0, 45, 0)
CreateEntityBody(Entity, #PB_Entity_StaticBody, 0, 0, 0)

;-- Fond du bassin
Mesh = CreateCube(#PB_Any, 5)
Material = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any, "beton1.png")))
Entity = CreateEntity(#PB_Any, MeshID(Mesh), MaterialID(Material))
ScaleEntity(Entity, 1,0.1,1)
MoveEntity(Entity, 0, -2.4, -14.8) 
CreateEntityBody(Entity, #PB_Entity_StaticBody, 1, 1, 1)

;-- L'eau du bassin
BlueWater = CausticWater::CreateGroupMaterial(#PB_Any, "blue*.bmp", 64, 160, #True)
Mesh = CreateCube(#PB_Any, 1) 
Water = CreateEntity(#PB_Any, MeshID(Mesh), #PB_Material_None)
ScaleEntity(Water, 4.90, 2.4, 4.90)
MoveEntity(Water, 0, -0.9, -14.8)
EntityRenderMode(Water, #PB_Shadow_None) ; Pas de projection d'ombre 
CausticWater::SetEntityGroupMaterial(Water, BlueWater)

;- Player Invisble
Mesh = CreateCube(#PB_Any, 1)
Player = CreateEntity(#PB_Any, MeshID(Mesh), #PB_Material_None)
HideEntity(Player, #True)
ScaleEntity(Player, 1, 4, 1)
MoveEntity(Player, 0, 2, 10)  
CreateEntityBody(Player, #PB_Entity_BoxBody, 0.5, 0, 0)
EntityAngularFactor(Player, 0, 1, 0) ;Reste droit 
EntityRenderMode(Player, #PB_Shadow_None) ;Pas d'ombre projeté

;Camera 
Camera = CreateCamera(#PB_Any, 0, 0, 100, 100)

; Boucle rendering
Repeat  
  ; Evenements window
  While WindowEvent() : Wend
  
  ; Mise à joue des textures caustics
  CausticWater::UpdateGroupMaterial(Door)
  CausticWater::UpdateGroupMaterial(PortalGround)
  CausticWater::UpdateGroupMaterial(Water)
  
  ; Evenements souris
  If ExamineMouse()
    ; Rotation du player
    Rotation = -MouseDeltaX() * 0.25   
    
    ; Hauteur de la camera 
    Hight + MouseDeltaY() * 0.1
    If Hight < -4
      Hight= -4
    EndIf        
  EndIf
  
  ; Evenements claviers
  If ExamineKeyboard()
    If KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q) 
      Rotation = 0.5 
    ElseIf KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_D)
      Rotation = -0.5
    EndIf
    
    If KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Z)
      PlayerSpeed = -1
    ElseIf KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_S)
      PlayerSpeed = 1
    Else
      PlayerSpeed = 0
    EndIf       
  EndIf
  
  ; Action joueur (Position, Rotation, Animation)
  RotateEntity(Player, 0, Rotation, 0, #PB_Relative) 
  MoveEntity(Player, 0, 0, PlayerSpeed, #PB_Absolute|#PB_Local) 
    
  ; La caméra suit le joueur
  CameraFollow(Camera, EntityID(Player), 0, EntityY(Player) + Hight, Distance, 1, 1, #True)
  
  ; Rendering de la scene
  RenderWorld(30)
  FlipBuffers()  
Until KeyboardReleased(#PB_Key_Escape) Or MouseButton(#PB_MouseButton_Middle)
