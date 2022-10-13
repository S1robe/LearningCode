//
// Created by owner on 10/5/22.
//
#pragma once // This is used to tell the compiler to only include one instance of this file ever in the binary.
#include <wx/wx.h>

// these ensure that this h file is created
#ifndef PLANNER_MAINFRAME_H
#define PLANNER_MAINFRAME_H

/**
 * In WX widgets, windows are called frames, with the root being this MainFrame
 */
class MainFrame : public wxFrame{

public:
    MainFrame(const wxString& title);   // We have just defined a public method for us to call.
};


#endif //PLANNER_MAINFRAME_H
