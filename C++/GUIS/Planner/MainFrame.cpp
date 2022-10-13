//
// Created by owner on 10/5/22.
//
#include "MainFrame.h"
#include <wx/wx.h>

/**
 * This is the way we implement a constructor from a .h file, this method calls its parent class constructor "wxFrame"
 * @param title The title to be shown on this gui.
 */
MainFrame::MainFrame(const wxString &title) : wxFrame(nullptr, wxID_ANY, title) {

}