; Effet Caustic
; 
; PureBasic 5.73,  6.0

EnableExplicit
IncludeFile "CausticEffect.pbi"

; DPI Résolution
Global drx.f, dry.f

; Caméras
Global Camera, Rot.f

; Entités
Global Mesh, Material, Cube, BlueWater

; Delta Time
Global dt.f

; Initialisatio environnement 3D
drx = DesktopResolutionX()
dry = DesktopResolutionY()
ExamineDesktops()
InitEngine3D(#PB_Engine3D_DebugLog) : InitSprite() : InitKeyboard() : InitMouse()
OpenWindow(0, 0, 0, DesktopWidth(0), DesktopHeight(0), "", #PB_Window_Maximize | #PB_Window_BorderLess)
OpenWindowedScreen(WindowID(0),0, 0, WindowWidth(0)*drx , WindowHeight(0)*dry) 

; Un peu de lumiere
CreateLight(#PB_Any, RGB(255, 255, 255), 10, 10, 10)

; Ciel
Add3DArchive("data/skybox/Early_morning.zip", #PB_3DArchive_Zip) 
SkyBox("Early_morning.jpg")

; Camera
Camera = CreateCamera(#PB_Any, 0, 0, 100, 100)

; Chargement des textures de l'effet caustic
; 64 Textures, On applique 
Add3DArchive("Data/textures/blue64/", #PB_3DArchive_FileSystem)
BlueWater = CausticWater::CreateGroupMaterial(#PB_Any, "blue*.bmp", 64, 160, #True)

; Une entité sur lequel sera appliqué les textures caustiques
Mesh = CreateCube(#PB_Any, 20)
Cube = CreateEntity(#PB_Any, MeshID(Mesh), #PB_Material_None)
CausticWater::SetEntityGroupMaterial(Cube, BlueWater)

; Boucle 3D
Repeat
  While WindowEvent() : Wend
  ExamineKeyboard()
  ExamineMouse()
  
  ; Mise à joue de l'effet caustic
  CausticWater::UpdateGroupMaterial(Cube)
  
  ; Rotation des entités
  RotateEntity(Cube, 0.1*(1+dt), 0.1*(1+dt), 0.1*(1+dt), #PB_Relative)
  
  ; Rotation de la camera principale
  Rot + 0.002 * (1+dt)
  MoveCamera(Camera, Cos(Rot)*50, 15, Sin(Rot)*50, #PB_Absolute)
  CameraLookAt(Camera, 0, 0, 0)
      
  ; Rendering
  dt = RenderWorld()/1000
  FlipBuffers()    
Until KeyboardReleased(#PB_Key_Escape) Or MouseButton(#PB_MouseButton_Middle)
