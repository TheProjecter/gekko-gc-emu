/*!
 * Copyright (C) 2005-2012 Gekko Emulator
 *
 * \file    sdl_keys.h
 * \author  ShizZy <shizzy247@gmail.com>
 * \date    2012-03-03
 * \brief   Implementation of a SDL keyboard GC controller interface
 *
 * \section LICENSE
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details at
 * http://www.gnu.org/copyleft/gpl.html
 *
 * Official project repository can be found at:
 * http://code.google.com/p/gekko-gc-emu/
 */

#ifndef INPUT_COMMON_SDL_KEYS_
#define INPUT_COMMON_SDL_KEYS_

#include "common.h"
#include "input_common.h"

namespace input_common {

class SDLKeys  : virtual public InputBase {
public:
    SDLKeys() {};
    ~SDLKeys() {};

    void Init();
    void PollEvent();
    void ShutDown();

private:
    /*!
     * \brief Sets the controller status from the keyboard using SDL
     * \param channel Channel of controller to set status of (0-3)
     * \param key SDL key pressed or released
     * \param state GCController::GCButtonState we're setting
     */
    void SDLKeys::SetControllerStatus(int channel, SDL_Keycode key, GCController::GCButtonState state);

    DISALLOW_COPY_AND_ASSIGN(SDLKeys);
};

} // namepsace

#endif //INPUT_COMMON_SDL_KEYS_