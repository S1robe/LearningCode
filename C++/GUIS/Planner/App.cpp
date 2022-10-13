//
// Created by owner on 10/5/22.
//

#include "App.h"
#include "MainFrame.h"
#include "wx/wx.h"

// In CPP there are many ways to call gui's, wxWidgest makes our life easy, we call this static method and it will
// Auto-detect the platform that we are running this on, generate the required code to create this gui, and then do it.
wxIMPLEMENT_APP(App);

/**
 * This is the implementation of our App.h file, GUI's instead  of main have an onInit function.
 * @return true to let the systme know that this gui has displayed correctly and can continue.
 */
bool App::onInit() {
    auto* mainframe = new MainFrame("First GUI");

    mainframe->SetClientSize(800, 600);
    mainframe->Show();

    std::cout << mainframe->GetScreenPosition().x;
    std::cout << mainframe->GetScreenPosition().y;
    return true;
}
