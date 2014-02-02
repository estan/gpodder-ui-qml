
/**
 *
 * gPodder QML UI Reference Implementation
 * Copyright (c) 2013, 2014, Thomas Perl <m@thp.io>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 */

import QtQuick 2.0

import 'util.js' as Util

ListModel {
    id: podcastListModel

    function reload() {
        py.call('main.load_podcasts', [], function (podcasts) {
            Util.updateModelFrom(podcastListModel, podcasts);
        });
    }

    property var connections: Connections {
        target: py

        onPodcastListChanged: {
            podcastListModel.reload();
        }

        onUpdatingPodcast: {
            for (var i=0; i<podcastListModel.count; i++) {
                var podcast = podcastListModel.get(i);
                if (podcast.id == podcast_id) {
                    podcastListModel.setProperty(i, 'updating', true);
                    break;
                }
            }
        }

        onUpdatedPodcast: {
            for (var i=0; i<podcastListModel.count; i++) {
                if (podcastListModel.get(i).id == podcast.id) {
                    podcastListModel.set(i, podcast);
                    break;
                }
            }
        }
    }
}