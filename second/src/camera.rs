use bevy::prelude::*;

#[derive(Debug)]
pub(crate) struct Camera;

impl Camera {
    pub(crate) fn setup(mut commands: Commands) {
        commands.spawn(Camera2dBundle::default());
    }
}
