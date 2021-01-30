#!/bin/bash
cd bin

install_name_tool -add_rpath @executable_path/../Frameworks/vlc AcfunQml.app/Contents/MacOS/AcfunQml 