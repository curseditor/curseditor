#include <vector>
#include <string>
#include <iostream>

#include "imtui/imtui.h"
#include "imgui/misc/cpp/imgui_stdlib.h"
#include "imtui/imtui-impl-ncurses.h"

int main()
{
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    auto screen = ImTui_ImplNcurses_Init(true);
    ImTui_ImplText_Init();

    bool demo = true;
    int nframes = 0;
    float fval = 1.23f;

    static char buf[16 * 1024] =
        R"(int main()
{
    printf("Hello, world!\n");
})";

    while (true)
    {
        ImTui_ImplNcurses_NewFrame();
        ImTui_ImplText_NewFrame();

        ImGui::NewFrame();

        ImGui::SetNextWindowPos(ImVec2(4, 27), ImGuiCond_Once);
        ImGui::SetNextWindowSize(ImVec2(50.0, 10.0), ImGuiCond_Once);
        ImGui::Begin("Hello, world!");

        ImGui::InputTextMultiline(
            "##src", // label (hidden with "##")
            buf,
            IM_ARRAYSIZE(buf),                       // byte capacity
            ImVec2(-FLT_MIN,                         // width  = fill X
                   ImGui::GetTextLineHeight() * 20), // height ≈20 lines
            ImGuiInputTextFlags_AllowTabInput);

        if (ImGui::Button("Exit program", {ImGui::GetContentRegionAvail().x, 2}))
        {
            break;
        }

        ImGui::End();

        ImGui::Render();

        ImTui_ImplText_RenderDrawData(ImGui::GetDrawData(), screen);
        ImTui_ImplNcurses_DrawScreen();
    }

    ImTui_ImplText_Shutdown();
    ImTui_ImplNcurses_Shutdown();

    ImGui::DestroyContext();

    return 0;
}