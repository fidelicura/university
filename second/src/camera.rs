use bevy::prelude::*;

use crate::player::PlayerScore;

#[derive(Debug, Component)]
pub(crate) struct Camera;

impl Camera {
    pub(crate) fn setup(score: Res<PlayerScore>, mut commands: Commands) {
        commands.spawn(Camera2dBundle::default());

        let score_size = Transform::from_xyz(-280., -200., 0.);
        let score_text_style = TextStyle {
            font_size: 30.,
            ..default()
        };
        let score_text = Text::from_section(format!("{}", score.amount), score_text_style);
        let score_bundle = TextBundle {
            text: score_text,
            transform: score_size,
            ..default()
        };

        commands.spawn(score_bundle);
    }

    pub(crate) fn update_score(state: Res<PlayerScore>, mut query: Query<&mut Text>) {
        if let Ok(mut text) = query.get_single_mut() {
            text.sections[0].value = format!("{}", state.amount);
        }
    }
}
