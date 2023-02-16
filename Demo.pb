; Effet Caustic
; 
; PureBasic 5.73,  6.0

EnableExplicit
IncludeFile "CausticEffect.pbi"

; Caméras
Define Camera, Rot.f

; Entités
Define Mesh, Material, Cube, BlueWater


; Initialisatio environnement 3D
InitEngine3D(#PB_Engine3D_DebugLog) : InitSprite() : InitKeyboard() : InitMouse()
OpenWindow(0, 0, 0, 0, 0, "", #PB_Window_Maximize | #PB_Window_BorderLess)
OpenWindowedScreen(WindowID(0),0, 0, WindowWidth(0) , WindowHeight(0)) 

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
  RotateEntity(Cube, 0.1, 0.1, 0.1, #PB_Relative)
  
  ; Rotation de la camera principale
  Rot + 0.002
  MoveCamera(Camera, Cos(Rot)*50, 15, Sin(Rot)*50, #PB_Absolute)
  CameraLookAt(Camera, 0, 0, 0)
      
  ; Rendering
  RenderWorld()
  FlipBuffers()    
Until KeyboardReleased(#PB_Key_Escape) Or MouseButton(#PB_MouseButton_Middle)
; IDE Options = PureBasic 6.01 LTS beta 2 (Windows - x64)
; CursorPosition = 32
; FirstLine = 28
; EnableXP