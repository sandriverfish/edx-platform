(function() {
    describe('VideoProgressSlider', function() {
        var state, videoPlayer, videoProgressSlider, oldOTBD;

        function initialize() {
            loadFixtures('video_all.html');
            state = new Video('#example');
            videoPlayer = state.videoPlayer;
            videoProgressSlider = state.videoProgressSlider;
        }

        beforeEach(function() {
            oldOTBD = window.onTouchBasedDevice;
            window.onTouchBasedDevice = jasmine.createSpy('onTouchBasedDevice')
                .andReturn(null);
        });

        afterEach(function() {
            $('source').remove();
            window.onTouchBasedDevice = oldOTBD;
        });

        describe('constructor', function() {
            describe('on a non-touch based device', function() {
                beforeEach(function() {
                    spyOn($.fn, 'slider').andCallThrough();
                    initialize();
                });

                it('build the slider', function() {
                    expect(videoProgressSlider.slider).toBe('.slider');
                    expect($.fn.slider).toHaveBeenCalledWith({
                        range: 'min',
                        change: videoProgressSlider.onChange,
                        slide: videoProgressSlider.onSlide,
                        stop: videoProgressSlider.onStop
                    });
                });

                it('build the seek handle', function() {
                    expect(videoProgressSlider.handle)
                        .toBe('.slider .ui-slider-handle');
                });
            });

            describe('on a touch-based device', function() {
                it('does not build the slider on iPhone', function() {

                    window.onTouchBasedDevice.andReturn(['iPhone']);
                    initialize();

                    expect(videoProgressSlider).toBeUndefined();

                    // We can't expect $.fn.slider not to have been called,
                    // because sliders are used in other parts of Video.
                });
                $.each(['iPad', 'Android'], function(index, device) {
                    it('build the slider on ' + device, function() {
                        window.onTouchBasedDevice.andReturn([device]);
                        initialize();
                        expect(videoProgressSlider.slider).toBeDefined();
                    });
                });
            });
        });

        describe('play', function() {
            beforeEach(function() {
                initialize();
            });

            describe('when the slider was already built', function() {
                var spy;

                beforeEach(function() {
                    spy = spyOn(videoProgressSlider, 'buildSlider');
                    spy.andCallThrough();
                    videoPlayer.play();
                });

                it('does not build the slider', function() {
                    expect(spy.callCount).toEqual(0);
                });
            });

            // Currently, the slider is not rebuilt if it does not exist.
        });

        describe('updatePlayTime', function() {
            beforeEach(function() {
                initialize();
            });

            describe('when frozen', function() {
                beforeEach(function() {
                    spyOn($.fn, 'slider').andCallThrough();
                    videoProgressSlider.frozen = true;
                    videoProgressSlider.updatePlayTime(20, 120);
                });

                it('does not update the slider', function() {
                    expect($.fn.slider).not.toHaveBeenCalled();
                });
            });

            describe('when not frozen', function() {
                beforeEach(function() {
                    spyOn($.fn, 'slider').andCallThrough();
                    videoProgressSlider.frozen = false;
                    videoProgressSlider.updatePlayTime({
                        time: 20,
                        duration: 120
                    });
                });

                it('update the max value of the slider', function() {
                    expect($.fn.slider).toHaveBeenCalledWith(
                        'option', 'max', 120
                    );
                });

                it('update current value of the slider', function() {
                    expect($.fn.slider).toHaveBeenCalledWith(
                        'option', 'value', 20
                    );
                });
            });
        });

        describe('onSlide', function() {
            beforeEach(function() {
                initialize();
                spyOn($.fn, 'slider').andCallThrough();
                spyOn(videoPlayer, 'onSlideSeek').andCallThrough();
            });

            // Disabled 12/30/13 due to flakiness in master
            xit('freeze the slider', function() {
                videoProgressSlider.onSlide(
                    jQuery.Event('slide'), { value: 20 }
                );

                expect(videoProgressSlider.frozen).toBeTruthy();
            });

            // Disabled 12/30/13 due to flakiness in master
            xit('trigger seek event', function() {
                videoProgressSlider.onSlide(
                    jQuery.Event('slide'), { value: 20 }
                );

                expect(videoPlayer.onSlideSeek).toHaveBeenCalled();
            });
        });

        describe('onStop', function() {

            beforeEach(function() {
                jasmine.Clock.useMock();

                initialize();
                spyOn(videoPlayer, 'onSlideSeek').andCallThrough();
            });

            // Disabled 12/30/13 due to flakiness in master
            xit('freeze the slider', function() {
                videoProgressSlider.onStop(
                    jQuery.Event('stop'), { value: 20 }
                );

                expect(videoProgressSlider.frozen).toBeTruthy();
            });

            // Disabled 12/30/13 due to flakiness in master
            xit('trigger seek event', function() {
                videoProgressSlider.onStop(
                    jQuery.Event('stop'), { value: 20 }
                );

                expect(videoPlayer.onSlideSeek).toHaveBeenCalled();
            });

            // Disabled 12/30/13 due to flakiness in master
            xit('set timeout to unfreeze the slider', function() {
                videoProgressSlider.onStop(
                    jQuery.Event('stop'), { value: 20 }
                );

                jasmine.Clock.tick(200);

                expect(videoProgressSlider.frozen).toBeFalsy();
            });
        });

        it('getRangeParams' , function() {
            var testCases = [
                    {
                        startTime: 10,
                        endTime: 20,
                        duration: 150
                    },
                    {
                        startTime: 90,
                        endTime: 100,
                        duration: 100
                    },
                    {
                        startTime: 0,
                        endTime: 200,
                        duration: 200
                    }
                ];

            initialize();

            $.each(testCases, function(index, testCase) {
                var step = 100/testCase.duration,
                    left = testCase.startTime*step,
                    width = testCase.endTime*step - left,
                    expectedParams = {
                        left: left + '%',
                        width: width + '%'
                    },
                    params = videoProgressSlider.getRangeParams(
                        testCase.startTime, testCase.endTime, testCase.duration
                    );

                expect(params).toEqual(expectedParams);
            });
        });

        describe('notifyThroughHandleEnd', function () {
            beforeEach(function () {
                initialize();

                spyOnEvent(videoProgressSlider.handle, 'focus');
                spyOn(videoProgressSlider, 'notifyThroughHandleEnd')
                    .andCallThrough();
            });

            it('params.end = true', function () {
                videoProgressSlider.notifyThroughHandleEnd({end: true});

                expect(videoProgressSlider.handle.attr('title'))
                    .toBe('video ended');

                expect('focus').toHaveBeenTriggeredOn(videoProgressSlider.handle);
            });

            it('params.end = false', function () {
                videoProgressSlider.notifyThroughHandleEnd({end: false});

                expect(videoProgressSlider.handle.attr('title'))
                    .toBe('video position');

                expect('focus').not.toHaveBeenTriggeredOn(videoProgressSlider.handle);
            });

            it('is called when video plays', function () {
                videoPlayer.play();

                waitsFor(function () {
                    return videoPlayer.isPlaying();
                }, 'duration is set, video is playing', 5000);

                runs(function () {
                    expect(videoProgressSlider.notifyThroughHandleEnd)
                        .toHaveBeenCalledWith({end: false});
                });
            });
        });
    });
}).call(this);
